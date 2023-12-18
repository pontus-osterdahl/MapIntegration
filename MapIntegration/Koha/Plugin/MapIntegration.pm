package Koha::Plugin::MapIntegration;

use Modern::Perl;
use Koha::Biblios;
use Koha::Items;
use Koha::Item;

use base qw(Koha::Plugins::Base);

our $VERSION = "0.1";

our $metadata = {
    name            => 'Map Integration',
    author          => 'imCode.com',
    date_authored   => '2023-12-01',
    date_updated    => "2023-12-07",
    minimum_version => '19.05.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'This plugin integrates maps.',
};

sub new {
    my ( $class, $args ) = @_;

    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    my $self = $class->SUPER::new($args);
    $self->{cgi} = CGI->new();

    return $self;
}

sub configure {
    my ( $self, $args ) = @_;

    my $cgi = $self->{'cgi'};

    unless ( $cgi->param('save')) {

        my $template = $self->get_template( { file => 'configure.tt' } );

        ## Grab value if exist
        $template->param(
            path_host => $self->retrieve_data('path_host'),
        );

        return $self->output_html( $template->output() );
    }
    else {
        $self->store_data(
            {
                path_host => $cgi->param('host')
            }
        );
        $self->go_home();
    }
}

sub create_path {
    my ( $self, $item ) = @_;

     my $host = $self->retrieve_data('path_host');
     my $ccode = $item->ccode;
     my $location = $item->location;
     my $callno = $item->itemcallnumber;

     my $text = $host . "?department=" . $ccode . "&location=" . $location . "&shelf=" . $callno;

     return $text;

}

sub opac_js {
    my ( $self ) = @_;
    my $cgi = $self->{'cgi'};
    my $script_name = $cgi->script_name;

    if ($script_name =~ /opac-detail\.pl/) {

    my $biblionumber = $cgi->param('biblionumber');

    my $biblio = Koha::Biblios->find($biblionumber);

    my $items = Koha::Items->search( { biblionumber => $biblionumber });

    my $js = "<script> const item_paths = [];";

      while (my $item = $items->next) {

        my $conte = $self->create_path($item);
        $js .= "item_paths.push(\"" . $conte . "\");";     
        
      }

    $js .= <<'JS'; 

    var title = $(".title").text();

    $('#holdingst').find("tbody").find("tr").each(function(index) { 
    var t = $(this).find(".call_no").text();
    var b = $.trim(t).split(' ');
    var shelf = b[0];  
    var wagnerGuidePath = item_paths[index];
    var callNoTd = $(this).find(".call_no");
    $(callNoTd).append("<a href=\"" + wagnerGuidePath + "\">" + " Locate this Book" + "</a>");
    });

JS

    $js .= "</script>";

    return $js;

    }
}

1;