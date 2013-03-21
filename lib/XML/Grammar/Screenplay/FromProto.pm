package XML::Grammar::Screenplay::FromProto;

use XML::Writer;

use MooX 'late';

extends("XML::Grammar::FictionBase::TagsTree2XML");

my $screenplay_ns = q{http://web-cpan.berlios.de/modules/XML-Grammar-Screenplay/screenplay-xml-0.2/};


our $VERSION = '0.12.0';


sub _init
{
    my ($self, $args) = @_;

    local $Parse::RecDescent::skip = "";

    my $parser_class =
        ($args->{parser_class} || "XML::Grammar::Screenplay::FromProto::Parser::QnD");

    $self->_parser(
        $parser_class->new()
    );

    return 0;
}


sub _output_tag
{
    my ($self, $args) = @_;

    my @start = @{$args->{start}};
    $self->_writer->startTag([$screenplay_ns,$start[0]], @start[1..$#start]);

    $args->{in}->($self, $args);

    $self->_writer->endTag();
}

sub _output_tag_with_childs
{
    my ($self, $args) = @_;

    return
        $self->_output_tag({
            %$args,
            'in' => sub {
                foreach my $child (@{$args->{elem}->_get_childs()})
                {
                    $self->_write_elem({elem => $child,});
                }
            },
        });
}

sub _handle_text_start
{
    my ($self, $elem) = @_;

    if ($elem->_short_isa("Saying"))
    {
        $self->_output_tag_with_childs(
            {
                start => ["saying", 'character' => $elem->character()],
                elem => $elem,
            },
        );
    }
    elsif ($elem->_short_isa("Description"))
    {
        $self->_output_tag_with_childs(
            {
                start => ["description"],
                elem => $elem,
            },
        );
    }
    elsif ($elem->_short_isa("Text"))
    {
        foreach my $child (@{$elem->_get_childs()})
        {
            $self->_write_elem({ elem => $child,},);
        }
    }
    else
    {
        Carp::confess ("Unknown element class - " . ref($elem) . "!");
    }
}

sub _paragraph_tag
{
    return "para";
}

sub _handle_elem_of_name_img
{
    my ($self, $elem) = @_;

    $self->_output_tag_with_childs(
        {
            start => [
                "image",
                "url" => $elem->lookup_attr("src"),
                "alt" => $elem->lookup_attr("alt"),
                "title" => $elem->lookup_attr("title"),
            ],
            elem => $elem,
        }
    );

    return;
}

sub _handle_elem_of_name_a
{
    my ($self, $elem) = @_;

    $self->_output_tag_with_childs(
        {
            start => ["ulink", "url" => $elem->lookup_attr("href")],
            elem => $elem,
        }
    );

    return;
}

sub _handle_elem_of_name_section
{
    my ($self, $elem) = @_;

    return $self->_handle_elem_of_name_s($elem);
}

sub _bold_tag_name
{
    return "bold";
}

sub _italics_tag_name
{
    return "italics";
}

sub _write_elem
{
    my ($self, $args) = @_;

    my $elem = $args->{elem};

    if (ref($elem) eq "")
    {
        $self->_writer->characters($elem);
    }
    elsif ($elem->_short_isa("Paragraph"))
    {
        $self->_output_tag_with_childs(
            {
               start => [$self->_paragraph_tag()],
                elem => $elem,
            },
        );
    }
    elsif ($elem->_short_isa("Element"))
    {
        $self->_write_Element_elem($elem);
    }
    elsif ($elem->_short_isa("Text"))
    {
        $self->_handle_text_start($elem);
    }
    elsif ($elem->_short_isa("Comment"))
    {
        $self->_writer->comment($elem->text());
    }
}

sub _write_scene
{
    my ($self, $args) = @_;

    my $scene = $args->{scene};

    my $tag = $scene->name;

    if (($tag eq "s") || ($tag eq "scene"))
    {
        my $id = $scene->lookup_attr("id");

        if (!defined($id))
        {
            Carp::confess("Unspecified id for scene!");
        }

        my $title = $scene->lookup_attr("title");
        my @t = (defined($title) ? (title => $title) : ());

        $self->_output_tag_with_childs(
            {
                'start' => ["scene", id => $id, @t],
                elem => $scene,
            }
        );
    }
    else
    {
        confess "Improper scene tag - should be '<s>' or '<scene>'!";
    }

    return;
}

sub _read_file
{
    my ($self, $filename) = @_;

    open my $in, "<", $filename or
        confess "Could not open the file \"$filename\" for slurping.";
    binmode $in, ":utf8";
    my $contents;
    {
        local $/;
        $contents = <$in>;
    }
    close($in);

    return $contents;
}

sub _calc_tree
{
    my ($self, $args) = @_;

    my $filename = $args->{source}->{file} or
        confess "Wrong filename given.";

    return $self->_parser->process_text($self->_read_file($filename));
}

has '_buffer' => (is => "rw");

sub convert
{
    my ($self, $args) = @_;

    # These should be un-commented for debugging.
    # local $::RD_HINT = 1;
    # local $::RD_TRACE = 1;

    # We need this so P::RD won't skip leading whitespace at lines
    # which are siginificant.

    my $tree = $self->_calc_tree($args);

    if (!defined($tree))
    {
        Carp::confess("Parsing failed.");
    }

    my $buffer = "";
    $self->_buffer(\$buffer);

    my $writer = XML::Writer->new(
        OUTPUT => $self->_buffer(),
        ENCODING => "utf-8",
        NAMESPACES => 1,
        PREFIX_MAP =>
        {
             $screenplay_ns => "",
        }
    );

    $writer->xmlDecl("utf-8");
    $writer->startTag([$screenplay_ns, "document"]);
    $writer->startTag([$screenplay_ns, "head"]);
    $writer->endTag();
    $writer->startTag([$screenplay_ns, "body"], "id" => "index",);

    # Now we're inside the body.
    $self->_writer($writer);

    $self->_write_scene({scene => $tree});

    # Ending the body
    $writer->endTag();

    $writer->endTag();

    return ${$self->_buffer()};
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

XML::Grammar::Screenplay::FromProto - module that converts well-formed
text representing a screenplay to an XML format.

=head1 VERSION

version 0.12.0

=head1 VERSION

Version 0.12.0

=head2 new()

Accepts no arguments so far. May take some time as the grammar is compiled
at that point.

=head2 meta()

Internal - (to settle pod-coverage.).

=head2 $self->convert({ source => { file => $path_to_file } })

Converts the file $path_to_file to XML and returns it.

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
