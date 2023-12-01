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

#sub install {
#    my $table = $self->get_qualified_table_name('wagnerguidepath');
#
#    return C4::Context->dbh->do( "
#        CREATE TABLE IF NOT EXISTS $table (
#            `id` INT(1) NOT NULL AUTO_INCREMENT,
#            `librarypath` VARCHAR( 255 ) NOT NULL,
#            `department` ` VARCHAR( 255 ),
#            `location` ` VARCHAR( 255 ),
#            `shelf` VARCHAR( 255 ),
#        ) ENGINE = INNODB;
#    " );     
#}

sub tool {
    my ( $self, $args ) = @_;

    my $cgi = $self->{'cgi'};

    my $template = $self->get_template( { file => 'configure.tt' } );

    print $cgi->header();
    print $template->output();

}

#generate link
sub opac_js {
    my ( $self ) = @_;
    my $cgi = $self->{'cgi'};
    
    my $lite = "hej_new";

    # how do we ow what item is preopac_detail_xslt_variablesented

     my $js = "<script>  console.log(" . $lite . ");</script>";

    return $js;
}

1;