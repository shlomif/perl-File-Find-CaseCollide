package File::Find::CaseCollide;

use strict;
use warnings;
use 5.014;
use File::Find::Object ();
use Moo;

has '_results' => ( is => 'rw' );
has '_ffo'     => ( is => 'rw' );
has 'dir'      => ( is => 'ro' );

sub _iter
{
    my ($self) = @_;
    if ( my $r = $self->_ffo->next_obj() )
    {
        if ( $r->is_dir() )
        {
            my %found;
            foreach my $fn ( @{ $self->_ffo->get_current_node_files_list() } )
            {
                push @{ $found{ lc $fn } }, $fn;
            }
            my @positives = grep { @{ $found{$_} } > 1 } ( keys %found );

            if (@positives)
            {
                $self->_results->{ $r->path() } =
                    +{ map { $_ => $found{$_} } @positives };
            }
        }
        return 1;
    }
    return;
}

sub find
{
    my ($self) = @_;

    $self->_results( {} );
    $self->_ffo( File::Find::Object->new( {}, $self->dir ) );

    while ( $self->_iter )
    {
    }

    return $self->_results;
}

1;

=head1 NAME

File::Find::CaseCollide - find collisions in filenames, differing only in case

=head1 METHODS

=head2 dir

Pass it as a parameter with a path to the directory tree to traverse.

=head2 $obj->find()

Traverses the tree and returns the collisions as a hash reference - hopefully
empty.

=cut

=cut
