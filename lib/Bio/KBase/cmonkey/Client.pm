package Bio::KBase::cmonkey::Client;

use JSON::RPC::Client;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

Bio::KBase::cmonkey::Client

=head1 DESCRIPTION


Module KBaseCmonkey version 1.0
This module provides a set of methods for work with cMonkey biclustering tool.

Data types summary
Input data types: 
ExpressionDataSeries represents a list of expression data samples that serve as an input of cMonkey.
ExpressionDataSample data type represents a sample of expression data for a single condition.
ExpressionDataPoint data type represents a relative expression value for a single gene.
Output data types:
CmonkeyRun data type represents data generated by a single run of cMonkey (run_infos table of cMonkey results)
CmonkeyNetwork data type represents bicluster network
CmonkeyCluter data type represents a single bicluster from cMonkey network, with links to genes, experimental conditions and motifs
CmonkeyMotif data type represents a single motif identifed for a bicluster

Methods summary
build_cmonkey_network - Starts cMonkey server run for a series of expression data and returns job ID of the run 
build_cmonkey_network_from_ws - Starts cMonkey server run for a series of expression data stored in workspace and returns job ID of the run
build_cmonkey_network_job_from_ws - Starts cMonkey server run for a series of expression data stored in workspace and returns job ID of the run


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => Bio::KBase::cmonkey::Client::RpcClient->new,
	url => $url,
    };

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my $token = Bio::KBase::AuthToken->new(@args);
	
	if (!$token->error_message)
	{
	    $self->{token} = $token->token;
	    $self->{client}->{token} = $token->token;
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




=head2 build_cmonkey_network

  $cmonkey_run_result = $obj->build_cmonkey_network($series, $params)

=over 4

=item Parameter and return types

=begin html

<pre>
$series is a Cmonkey.ExpressionDataSeries
$params is a Cmonkey.CmonkeyRunParameters
$cmonkey_run_result is a Cmonkey.CmonkeyRunResult
ExpressionDataSeries is a reference to a hash where the following keys are defined:
	id has a value which is a string
	samples has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataSample
ExpressionDataSample is a reference to a hash where the following keys are defined:
	id has a value which is a string
	description has a value which is a string
	points has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataPoint
ExpressionDataPoint is a reference to a hash where the following keys are defined:
	gene_id has a value which is a string
	expression_value has a value which is a float
CmonkeyRunParameters is a reference to a hash where the following keys are defined:
	no_operons has a value which is an int
	no_string has a value which is an int
	no_networks has a value which is an int
	no_motifs has a value which is an int
CmonkeyRunResult is a reference to a hash where the following keys are defined:
	id has a value which is a string
	start_time has a value which is a string
	finish_time has a value which is a string
	iterations_number has a value which is an int
	last_iteration has a value which is an int
	organism has a value which is a string
	rows_number has a value which is an int
	columns_number has a value which is an int
	clusters_number has a value which is an int
	parameters has a value which is a Cmonkey.CmonkeyRunParameters
	network has a value which is a Cmonkey.CmonkeyNetwork
CmonkeyNetwork is a reference to a hash where the following keys are defined:
	id has a value which is a string
	iteration has a value which is an int
	clusters has a value which is a reference to a list where each element is a Cmonkey.CmonkeyCluster
CmonkeyCluster is a reference to a hash where the following keys are defined:
	id has a value which is a string
	residual has a value which is a float
	dataset_ids has a value which is a reference to a list where each element is a string
	gene_ids has a value which is a reference to a list where each element is a string
	motifs has a value which is a reference to a list where each element is a Cmonkey.CmonkeyMotif
CmonkeyMotif is a reference to a hash where the following keys are defined:
	id has a value which is a string
	seq_type has a value which is a string
	pssm_id has a value which is an int
	evalue has a value which is a float
	pssm_rows has a value which is a reference to a list where each element is a reference to a list where each element is a float
	hits has a value which is a reference to a list where each element is a Cmonkey.MastHit
	sites has a value which is a reference to a list where each element is a Cmonkey.SiteMeme
MastHit is a reference to a hash where the following keys are defined:
	sequence_id has a value which is a string
	strand has a value which is a string
	pssm_id has a value which is a string
	hit_start has a value which is an int
	hit_end has a value which is an int
	score has a value which is a float
	hit_pvalue has a value which is a float
SiteMeme is a reference to a hash where the following keys are defined:
	source_sequence_id has a value which is a string
	start has a value which is an int
	pvalue has a value which is a float
	left_flank has a value which is a string
	right_flank has a value which is a string
	sequence has a value which is a string

</pre>

=end html

=begin text

$series is a Cmonkey.ExpressionDataSeries
$params is a Cmonkey.CmonkeyRunParameters
$cmonkey_run_result is a Cmonkey.CmonkeyRunResult
ExpressionDataSeries is a reference to a hash where the following keys are defined:
	id has a value which is a string
	samples has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataSample
ExpressionDataSample is a reference to a hash where the following keys are defined:
	id has a value which is a string
	description has a value which is a string
	points has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataPoint
ExpressionDataPoint is a reference to a hash where the following keys are defined:
	gene_id has a value which is a string
	expression_value has a value which is a float
CmonkeyRunParameters is a reference to a hash where the following keys are defined:
	no_operons has a value which is an int
	no_string has a value which is an int
	no_networks has a value which is an int
	no_motifs has a value which is an int
CmonkeyRunResult is a reference to a hash where the following keys are defined:
	id has a value which is a string
	start_time has a value which is a string
	finish_time has a value which is a string
	iterations_number has a value which is an int
	last_iteration has a value which is an int
	organism has a value which is a string
	rows_number has a value which is an int
	columns_number has a value which is an int
	clusters_number has a value which is an int
	parameters has a value which is a Cmonkey.CmonkeyRunParameters
	network has a value which is a Cmonkey.CmonkeyNetwork
CmonkeyNetwork is a reference to a hash where the following keys are defined:
	id has a value which is a string
	iteration has a value which is an int
	clusters has a value which is a reference to a list where each element is a Cmonkey.CmonkeyCluster
CmonkeyCluster is a reference to a hash where the following keys are defined:
	id has a value which is a string
	residual has a value which is a float
	dataset_ids has a value which is a reference to a list where each element is a string
	gene_ids has a value which is a reference to a list where each element is a string
	motifs has a value which is a reference to a list where each element is a Cmonkey.CmonkeyMotif
CmonkeyMotif is a reference to a hash where the following keys are defined:
	id has a value which is a string
	seq_type has a value which is a string
	pssm_id has a value which is an int
	evalue has a value which is a float
	pssm_rows has a value which is a reference to a list where each element is a reference to a list where each element is a float
	hits has a value which is a reference to a list where each element is a Cmonkey.MastHit
	sites has a value which is a reference to a list where each element is a Cmonkey.SiteMeme
MastHit is a reference to a hash where the following keys are defined:
	sequence_id has a value which is a string
	strand has a value which is a string
	pssm_id has a value which is a string
	hit_start has a value which is an int
	hit_end has a value which is an int
	score has a value which is a float
	hit_pvalue has a value which is a float
SiteMeme is a reference to a hash where the following keys are defined:
	source_sequence_id has a value which is a string
	start has a value which is an int
	pvalue has a value which is a float
	left_flank has a value which is a string
	right_flank has a value which is a string
	sequence has a value which is a string


=end text

=item Description

Starts cMonkey server run for a series of expression data and returns run result 
ExpressionDataSeries series - series of expression data samples for cMonkey run
CmonkeyRunParameters params - parameters of cMonkey run
string job_id - identifier of cMonkey job

=back

=cut

sub build_cmonkey_network
{
    my($self, @args) = @_;

# Authentication: none

    if ((my $n = @args) != 2)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function build_cmonkey_network (received $n, expecting 2)");
    }
    {
	my($series, $params) = @args;

	my @_bad_arguments;
        (ref($series) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"series\" (value was \"$series\")");
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 2 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to build_cmonkey_network:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'build_cmonkey_network');
	}
    }

    my $result = $self->{client}->call($self->{url}, {
	method => "Cmonkey.build_cmonkey_network",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{code},
					       method_name => 'build_cmonkey_network',
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method build_cmonkey_network",
					    status_line => $self->{client}->status_line,
					    method_name => 'build_cmonkey_network',
				       );
    }
}



=head2 build_cmonkey_network_from_ws

  $cmonkey_run_result_id = $obj->build_cmonkey_network_from_ws($ws_id, $collection_id, $params)

=over 4

=item Parameter and return types

=begin html

<pre>
$ws_id is a string
$collection_id is a string
$params is a Cmonkey.CmonkeyRunParameters
$cmonkey_run_result_id is a string
CmonkeyRunParameters is a reference to a hash where the following keys are defined:
	no_operons has a value which is an int
	no_string has a value which is an int
	no_networks has a value which is an int
	no_motifs has a value which is an int

</pre>

=end html

=begin text

$ws_id is a string
$collection_id is a string
$params is a Cmonkey.CmonkeyRunParameters
$cmonkey_run_result_id is a string
CmonkeyRunParameters is a reference to a hash where the following keys are defined:
	no_operons has a value which is an int
	no_string has a value which is an int
	no_networks has a value which is an int
	no_motifs has a value which is an int


=end text

=item Description

Starts cMonkey server run for a series of expression data stored in workspace and returns ID of the run result object
string ws_id - workspace id
string series_id - kbase id of expression data series for cMonkey run
CmonkeyRunParameters params - parameters of cMonkey run
string job_id - identifier of cMonkey job

=back

=cut

sub build_cmonkey_network_from_ws
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 3)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function build_cmonkey_network_from_ws (received $n, expecting 3)");
    }
    {
	my($ws_id, $collection_id, $params) = @args;

	my @_bad_arguments;
        (!ref($ws_id)) or push(@_bad_arguments, "Invalid type for argument 1 \"ws_id\" (value was \"$ws_id\")");
        (!ref($collection_id)) or push(@_bad_arguments, "Invalid type for argument 2 \"collection_id\" (value was \"$collection_id\")");
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 3 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to build_cmonkey_network_from_ws:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'build_cmonkey_network_from_ws');
	}
    }

    my $result = $self->{client}->call($self->{url}, {
	method => "Cmonkey.build_cmonkey_network_from_ws",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{code},
					       method_name => 'build_cmonkey_network_from_ws',
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method build_cmonkey_network_from_ws",
					    status_line => $self->{client}->status_line,
					    method_name => 'build_cmonkey_network_from_ws',
				       );
    }
}



=head2 build_cmonkey_network_job_from_ws

  $cmonkey_run_result_job_id = $obj->build_cmonkey_network_job_from_ws($ws_id, $series_id, $params)

=over 4

=item Parameter and return types

=begin html

<pre>
$ws_id is a string
$series_id is a string
$params is a Cmonkey.CmonkeyRunParameters
$cmonkey_run_result_job_id is a string
CmonkeyRunParameters is a reference to a hash where the following keys are defined:
	no_operons has a value which is an int
	no_string has a value which is an int
	no_networks has a value which is an int
	no_motifs has a value which is an int

</pre>

=end html

=begin text

$ws_id is a string
$series_id is a string
$params is a Cmonkey.CmonkeyRunParameters
$cmonkey_run_result_job_id is a string
CmonkeyRunParameters is a reference to a hash where the following keys are defined:
	no_operons has a value which is an int
	no_string has a value which is an int
	no_networks has a value which is an int
	no_motifs has a value which is an int


=end text

=item Description

Starts cMonkey server run for a series of expression data stored in workspace and returns job ID of the run
string ws_id - workspace id
string series_id - kbase id of expression data series for cMonkey run
CmonkeyRunParameters params - parameters of cMonkey run
string job_id - identifier of cMonkey job

=back

=cut

sub build_cmonkey_network_job_from_ws
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 3)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function build_cmonkey_network_job_from_ws (received $n, expecting 3)");
    }
    {
	my($ws_id, $series_id, $params) = @args;

	my @_bad_arguments;
        (!ref($ws_id)) or push(@_bad_arguments, "Invalid type for argument 1 \"ws_id\" (value was \"$ws_id\")");
        (!ref($series_id)) or push(@_bad_arguments, "Invalid type for argument 2 \"series_id\" (value was \"$series_id\")");
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 3 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to build_cmonkey_network_job_from_ws:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'build_cmonkey_network_job_from_ws');
	}
    }

    my $result = $self->{client}->call($self->{url}, {
	method => "Cmonkey.build_cmonkey_network_job_from_ws",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{code},
					       method_name => 'build_cmonkey_network_job_from_ws',
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method build_cmonkey_network_job_from_ws",
					    status_line => $self->{client}->status_line,
					    method_name => 'build_cmonkey_network_job_from_ws',
				       );
    }
}



sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, {
        method => "Cmonkey.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'build_cmonkey_network_job_from_ws',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method build_cmonkey_network_job_from_ws",
            status_line => $self->{client}->status_line,
            method_name => 'build_cmonkey_network_job_from_ws',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for Bio::KBase::cmonkey::Client\n";
    }
    if ($sMajor == 0) {
        warn "Bio::KBase::cmonkey::Client version is $svr_version. API subject to change.\n";
    }
}

=head1 TYPES



=head2 ExpressionDataPoint

=over 4



=item Description

Represents a particular data point from gene expression data set
string gene_id - KBase gene identifier
float expression_value - relative expression value


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
gene_id has a value which is a string
expression_value has a value which is a float

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
gene_id has a value which is a string
expression_value has a value which is a float


=end text

=back



=head2 ExpressionDataSample

=over 4



=item Description

ExpressionDataSample represents set of expression data
string id - identifier of data set
string description - description of data set`
list<ExpressionDataPoint> points - data points


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
description has a value which is a string
points has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataPoint

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
description has a value which is a string
points has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataPoint


=end text

=back



=head2 ExpressionDataSeries

=over 4



=item Description

ExpressionDataSeries represents collection of expression data samples
string id - identifier of the collection
list<ExpressionDataSample> samples - data sets


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
samples has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataSample

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
samples has a value which is a reference to a list where each element is a Cmonkey.ExpressionDataSample


=end text

=back



=head2 MastHit

=over 4



=item Description

Represents a particular MAST hit
string sequence_id - name of sequence
string strand - strand ("+" or "-")
string pssm_id - name of motif
int hit_start - start position of hit
int hit_end - end position of hit
float score - hit score
float hit_pvalue - hit p-value


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
sequence_id has a value which is a string
strand has a value which is a string
pssm_id has a value which is a string
hit_start has a value which is an int
hit_end has a value which is an int
score has a value which is a float
hit_pvalue has a value which is a float

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
sequence_id has a value which is a string
strand has a value which is a string
pssm_id has a value which is a string
hit_start has a value which is an int
hit_end has a value which is an int
score has a value which is a float
hit_pvalue has a value which is a float


=end text

=back



=head2 PssmRow

=over 4



=item Description

Represents a single row of PSSM
int rowNumber - number of PSSM row
float aWeight 
float cWeight
float gWeight
float tWeight


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
row_number has a value which is an int
a_weight has a value which is a float
c_weight has a value which is a float
g_weight has a value which is a float
t_weight has a value which is a float

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
row_number has a value which is an int
a_weight has a value which is a float
c_weight has a value which is a float
g_weight has a value which is a float
t_weight has a value which is a float


=end text

=back



=head2 SiteMeme

=over 4



=item Description

Represents a particular site from MEME motif description 
string source_sequence_id - ID of sequence where the site was found
int start - position of site start 
float pvalue - site P-value
string left_flank - sequence of left flank
string sequence - sequence of site
string right_flank - sequence of right flank


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
source_sequence_id has a value which is a string
start has a value which is an int
pvalue has a value which is a float
left_flank has a value which is a string
right_flank has a value which is a string
sequence has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
source_sequence_id has a value which is a string
start has a value which is an int
pvalue has a value which is a float
left_flank has a value which is a string
right_flank has a value which is a string
sequence has a value which is a string


=end text

=back



=head2 CmonkeyMotif

=over 4



=item Description

Represents motif generated by cMonkey with a list of hits in upstream sequences
string CmonkeyMotifId - identifier of MotifCmonkey
string seqType - type of sequence
int pssm_id - number of motif
float evalue - motif e-value
list<PssmRow> pssm - PSSM 
list<HitMast> hits - hits (motif annotations)
list<SiteMeme> sites - training set


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
seq_type has a value which is a string
pssm_id has a value which is an int
evalue has a value which is a float
pssm_rows has a value which is a reference to a list where each element is a reference to a list where each element is a float
hits has a value which is a reference to a list where each element is a Cmonkey.MastHit
sites has a value which is a reference to a list where each element is a Cmonkey.SiteMeme

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
seq_type has a value which is a string
pssm_id has a value which is an int
evalue has a value which is a float
pssm_rows has a value which is a reference to a list where each element is a reference to a list where each element is a float
hits has a value which is a reference to a list where each element is a Cmonkey.MastHit
sites has a value which is a reference to a list where each element is a Cmonkey.SiteMeme


=end text

=back



=head2 CmonkeyCluster

=over 4



=item Description

Represents bicluster generated by cMonkey
string id - identifier of bicluster
float residual - residual
list<string> dataset_ids - list of experimental conditions 
list<string> gene_ids - list of genes from bicluster
list<CmonkeyMotif> motifs - list of motifs identified for the bicluster, converted to MEME format


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
residual has a value which is a float
dataset_ids has a value which is a reference to a list where each element is a string
gene_ids has a value which is a reference to a list where each element is a string
motifs has a value which is a reference to a list where each element is a Cmonkey.CmonkeyMotif

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
residual has a value which is a float
dataset_ids has a value which is a reference to a list where each element is a string
gene_ids has a value which is a reference to a list where each element is a string
motifs has a value which is a reference to a list where each element is a Cmonkey.CmonkeyMotif


=end text

=back



=head2 CmonkeyNetwork

=over 4



=item Description

Represents network generated by a single run of cMonkey
string id - identifier of cMonkey-generated network
int iteration - number of the last iteration
list<CmonkeyCluster> clusters - list of biclusters


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
iteration has a value which is an int
clusters has a value which is a reference to a list where each element is a Cmonkey.CmonkeyCluster

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
iteration has a value which is an int
clusters has a value which is a reference to a list where each element is a Cmonkey.CmonkeyCluster


=end text

=back



=head2 CmonkeyRunParameters

=over 4



=item Description

Contains parameters of a cMonkey run
int no_operons = <0|1> - if 1, MicrobesOnline operons data will not be used
int no_string = <0|1> - if 1, STRING data will not be used
int no_networks = <0|1> - if 1, Network scoring will not be used
int no_motifs = <0|1> - if 1, Motif scoring will not be used


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
no_operons has a value which is an int
no_string has a value which is an int
no_networks has a value which is an int
no_motifs has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
no_operons has a value which is an int
no_string has a value which is an int
no_networks has a value which is an int
no_motifs has a value which is an int


=end text

=back



=head2 CmonkeyRunResult

=over 4



=item Description

Represents data from a single run of cMonkey
string id - identifier of cMonkey run
string start_time - start time of cMonkey run
string finish_time - end time of cMonkey run
int iterations_number - number of iterations
int last_iteration - last iteration
string organism - organism
int rows_number - number of rows
int columns_number - number of columns
int clusters_number - number of clusters
CmonkeyRunParameters parameters - run parameters
CmonkeyNetwork network;


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
start_time has a value which is a string
finish_time has a value which is a string
iterations_number has a value which is an int
last_iteration has a value which is an int
organism has a value which is a string
rows_number has a value which is an int
columns_number has a value which is an int
clusters_number has a value which is an int
parameters has a value which is a Cmonkey.CmonkeyRunParameters
network has a value which is a Cmonkey.CmonkeyNetwork

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
start_time has a value which is a string
finish_time has a value which is a string
iterations_number has a value which is an int
last_iteration has a value which is an int
organism has a value which is a string
rows_number has a value which is an int
columns_number has a value which is an int
clusters_number has a value which is an int
parameters has a value which is a Cmonkey.CmonkeyRunParameters
network has a value which is a Cmonkey.CmonkeyNetwork


=end text

=back



=cut

package Bio::KBase::cmonkey::Client::RpcClient;
use base 'JSON::RPC::Client';

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $obj) = @_;
    my $result;

    if ($uri =~ /\?/) {
       $result = $self->_get($uri);
    }
    else {
        Carp::croak "not hashref." unless (ref $obj eq 'HASH');
        $result = $self->_post($uri, $obj);
    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
