package Koha::Plugin::MapIntegration;

use Modern::Perl;
use Koha::Biblios;
use Koha::Items;
use Koha::Item;

use base qw(Koha::Plugins::Base);

our $VERSION = "0.1";

our $metadata = {
    name            => 'Map Integration',
    author          => 'imcode.com',
    date_authored   => '2023-12-01',
    date_updated    => "2023-12-06",
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

    my $biblionumber = $cgi->param('biblionumber');

    my $biblio = Koha::Biblios->find($biblionumber);

    my $items = Koha::Items->search( { biblionumber => $biblionumber });

    #currently first item to log only
    while (my $item = $items->next) {

        my $conte = $self->create_path($item);
        my $js = "<script>  console.log('" . $conte . "');</script>";

        return $js;
    
    }


}

1;