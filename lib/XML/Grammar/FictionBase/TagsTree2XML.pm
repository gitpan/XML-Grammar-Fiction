package XML::Grammar::FictionBase::TagsTree2XML;

use MooX 'late';

our $VERSION = '0.12.5';

use XML::Writer;
use HTML::Entities ();

use XML::Grammar::Fiction::FromProto::Nodes;



has '_parser_class' =>
(
    is => "ro",
    isa => "Str",
    init_arg => "parser_class",
    default => "XML::Grammar::Fiction::FromProto::Parser::QnD",
);

has "_parser" => (
    'isa' => "XML::Grammar::Fiction::FromProto::Parser",
    'is' => "rw",
    lazy => 1,
    default => sub {
        my $self = shift;
        return $self->_parser_class->new();
    },
);

has "_writer" => ('isa' => "XML::Writer", 'is' => "rw");

my %passthrough_elem =
(
    b => sub { return shift->_bold_tag_name(); },
    i => sub { return shift->_italics_tag_name(); },
);

sub _calc_passthrough_cb
{
    my ($self, $name) = @_;

    if (exists($passthrough_elem{$name}))
    {
        return $passthrough_elem{$name};
    }
    else
    {
        return undef();
    }
}

sub _calc_passthrough_name
{
    my ($self, $name, $elem) = @_;

    my $cb = $self->_calc_passthrough_cb($name);

    if (ref($cb) eq 'CODE')
    {
        return $cb->($self, $name, $elem,);
    }
    else
    {
        return $cb;
    }
}

sub _write_Element_elem
{
    my ($self, $elem) = @_;

    my $name = $elem->name();

    if ($elem->_short_isa("InnerDesc"))
    {
        $self->_output_tag_with_childs(
            {
                start => ["inlinedesc"],
                elem => $elem,
            }
        );
        return;
    }
    elsif (defined(my $out_name = $self->_calc_passthrough_name($name, $elem)))
    {
        return $self->_output_tag_with_childs(
            {
                start => [$out_name],
                elem => $elem,
            }
        );
    }
    else
    {
        my $method = "_handle_elem_of_name_$name";

        $self->$method($elem);

        return;
    }
}

sub _handle_elem_of_name_s
{
    my ($self, $elem) = @_;

    $self->_write_scene({scene => $elem});
}

sub _handle_elem_of_name_br
{
    my ($self, $elem) = @_;

    $self->_writer->emptyTag("br");

    return;
}

sub _convert_while_handling_errors
{
    my ($self, $args) = @_;

    eval {
        my $output_xml = $self->convert(
            $args->{convert_args},
        );

        open my $out, ">", $args->{output_filename};
        binmode $out, ":utf8";
        print {$out} $output_xml;
        close($out);
    };

    # Error handling.

    my $e;
    if ($e = Exception::Class->caught("XML::Grammar::Fiction::Err::Parse::TagsMismatch"))
    {
        warn $e->error(), "\n";
        warn "Open: ", $e->opening_tag->name(),
            " at line ", $e->opening_tag->line(), "\n"
            ;
        warn "Close: ",
            $e->closing_tag->name(), " at line ",
            $e->closing_tag->line(), "\n";

        exit(-1);
    }
    elsif ($e = Exception::Class->caught("XML::Grammar::Fiction::Err::Parse::LineError"))
    {
        warn $e->error(), "\n";
        warn "At line ", $e->line(), "\n";
        exit(-1);
    }
    elsif ($e = Exception::Class->caught("XML::Grammar::Fiction::Err::Parse::TagNotClosedAtEOF"))
    {
        warn $e->error(), "\n";
        warn "Open: ", $e->opening_tag->name(),
            " at line ", $e->opening_tag->line(), "\n"
            ;

        exit(-1);
    }
    elsif ($e = Exception::Class->caught())
    {
        if (ref($e))
        {
            $e->rethrow();
        }
        else
        {
            die $e;
        }
    }

    return;
}


1;

__END__

=pod

=encoding utf-8

=head1 NAME

XML::Grammar::FictionBase::TagsTree2XML - base class for the tags-tree
to XML converters.

=head1 VERSION

version 0.12.5

=head1 VERSION

Version 0.12.5

=head2 meta()

Internal - (to settle pod-coverage.).

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://rt.cpan.org/NoAuth/Bugs.html?Dist=XML-Grammar-Fiction or by email to
bug-xml-grammar-fiction@rt.cpan.org.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc XML::Grammar::Fiction

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<http://metacpan.org/release/XML-Grammar-Fiction>

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/XML-Grammar-Fiction>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=XML-Grammar-Fiction>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annotations of Perl module documentation.

L<http://annocpan.org/dist/XML-Grammar-Fiction>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/XML-Grammar-Fiction>

=item *

CPAN Forum

The CPAN Forum is a web forum for discussing Perl modules.

L<http://cpanforum.com/dist/XML-Grammar-Fiction>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.perl.org/dist/overview/XML-Grammar-Fiction>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/X/XML-Grammar-Fiction>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=XML-Grammar-Fiction>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=XML::Grammar::Fiction>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-xml-grammar-fiction at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=XML-Grammar-Fiction>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<http://bitbucket.org/shlomif/perl-XML-Grammar-Fiction>

  hg clone ssh://hg@bitbucket.org/shlomif/perl-XML-Grammar-Fiction

=cut
