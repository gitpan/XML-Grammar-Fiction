package XML::Grammar::Fiction::FromProto::Nodes;

use strict;
use warnings;

use List::Util ();


our $VERSION = '0.11.1';

package XML::Grammar::Fiction::FromProto::Node;

use MooX 'late';

sub _short_isa
{
    my $self = shift;
    my $isa_classish = shift;

    return
        $self->isa(
            "XML::Grammar::Fiction::FromProto::Node::$isa_classish"
        );
}

package XML::Grammar::Fiction::FromProto::Node::WithContent;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node");

has 'children' => (
    isa => 'XML::Grammar::Fiction::FromProto::Node::List',
    is => 'rw'
);

sub _get_childs
{
    my $self = shift;

    my $childs = $self->children->contents();

    return $childs || [];
}

package XML::Grammar::Fiction::FromProto::Node::Element;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node::WithContent");

has 'name' => (isa => 'Str', is => 'rw');
has 'attrs' => (isa => 'ArrayRef', is => 'rw');
has 'open_line' => (isa => 'Maybe[Int]', is => 'rw');

sub lookup_attr
{
    my ($self, $attr_name) = @_;

    my $pair = List::Util::first { $_->{key} eq $attr_name } (@{$self->attrs()});

    if (!defined($pair))
    {
        return undef;
    }
    else
    {
        return $pair->{value};
    }
}

package XML::Grammar::Fiction::FromProto::Node::List;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node");

has 'contents' => (isa => "ArrayRef", is => "rw");

package XML::Grammar::Fiction::FromProto::Node::Text;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node::WithContent");

sub get_text
{
    my ($self, $re) = @_;

    return $self->children->contents->[0];
}

package XML::Grammar::Fiction::FromProto::Node::Saying;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node::Text");

has 'character' => (isa => "Str", is => "rw");

package XML::Grammar::Fiction::FromProto::Node::Description;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node::Text");

package XML::Grammar::Fiction::FromProto::Node::Paragraph;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node::Element");

package XML::Grammar::Fiction::FromProto::Node::InnerDesc;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node::Element");

sub name
{
    return "inlinedesc";
}

package XML::Grammar::Fiction::FromProto::Node::Comment;

use MooX 'late';

extends("XML::Grammar::Fiction::FromProto::Node");

has "text" => (isa => "Str", is => "rw");

1;

__END__

=pod

=encoding utf-8

=head1 NAME

XML::Grammar::Fiction::FromProto::Nodes - contains several nodes for
use in XML::Grammar::Fiction::FromProto.

=head1 VERSION

version 0.11.1

=head1 DESCRIPTION

Contains several nodes.

=head1 VERSION

Version 0.11.1

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
