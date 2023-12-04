package Koha::Plugin::PathIntegration;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

our $VERSION = "0.1";

our $metadata = {
    name            => 'Path_Integration',
    author          => 'Pontus Österdahl',
    date_authored   => '2023-12-01',
    date_updated    => "2023-12-01",
    minimum_version => '19.05.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'this plugin is test',
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

sub opac_js {
    my ( $self ) = @_;
    my $cgi = $self->{'cgi'};
    
    my $lite = "hej_new";

    # how do we ow what item is preopac_detail_xslt_variablesented

     my $js = "<script>  console.log(" . $lite . ");</script>";

    return $js;
}

1;