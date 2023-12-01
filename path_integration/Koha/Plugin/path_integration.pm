package Koha::Plugin::NewPlugin10;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

our $VERSION = "0.1";

our $metadata = {
    name            => 'Plugin_new5',
    author          => 'Plugin_new5',
    date_authored   => '2021-03-09',
    date_updated    => "2021-03-09",
    minimum_version => '19.05.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'this plugin adds zomething',
};

sub new {
    my ( $class, $args ) = @_;

    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    my $self = $class->SUPER::new($args);
    $self->{cgi} = CGI->new();

    return $self;
}

#create wagnerpath

#configurio or reae path

#sub install_not {
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
#t}

sub tool {
    my ( $self, $args ) = @_;

    my $cgi = $self->{'cgi'};

    # Here return code which let configuraion of wagnerpath

    my $cgi = $self->{'cgi'};

    my $template = $self->get_template( { file => 'configure.tt' } );

    print $cgi->header();
    print $template->output();

    # $self->output_html("<h1>hej</h1>")
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