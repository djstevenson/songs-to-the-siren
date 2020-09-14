package SongsToTheSiren::Test::Forms::Fields::Render::Base;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Deep qw/ cmp_deeply /;

extends 'SongsToTheSiren::Test::Base';

use SongsToTheSiren::Form::Field;
use SongsToTheSiren::Test::Forms::MockForm;

# Tests the general structure of the HTML, e.g. that we're in
# a div.form_group
#
# Example simple render (reformatted):
#  <div class="form-group">
#     <label for="new-song-artist">Artist</label>
#     <input type="text" id="new-song-artist" name="artist"  class="form-control " value=""/>
#     <span id="error-new-song-artist" class=""></span>
#  </div>
#
# If the field has an error, this becomes:
#  <div class="form-group">
#     <label for="new-song-artist">Artist</label>
#     <input type="text" id="new-song-artist" name="artist"  class="form-control is-invalid" value=""/>
#     <span id="error-new-song-artist" class="text-danger"></span>
#  </div>
#
# Class names here are from Bootstrap forms CSS



# _run_test: Generic method that is called by the individual test methods to
# separate out common code

sub _run_test {
    my ($self, $type, $args) = @_;

	my $mock_form = SongsToTheSiren::Test::Forms::MockForm->new;

    my $field_args      = $args->{field_args};
    my $field_type      = $args->{field_type};
    my $exp_label_attrs = $args->{exp_label_attrs};
    my $exp_label       = $args->{exp_label};
    my $exp_input_attrs = $args->{exp_input_attrs};

    my $field = $self->_make_field($type, $field_args);

    my $html = $field->render($mock_form);
    my $dom = Mojo::DOM->new($html);

    ok($dom->at('div')->matches('.form-group'), 'Root is a div with form-group class');
    my $label = $dom->at('div.form-group > label');
    ok($label, 'Root div encloses a label');
    cmp_deeply($label->attr, $exp_label_attrs, 'Got expected attrs for label');
    is($label->text, $exp_label, 'Got expected label text');

    my $sel = qq{div.form-group > ${field_type}.form-control};
    my $input = $dom->at($sel);
    ok($input, qq{Root div encloses ${field_type} with .form-control});
    cmp_deeply($input->attr, $exp_input_attrs, 'Got expected attrs for input');

    my $error_span = $dom->at('div.form-group > span.text-danger');
    if (exists $field_args->{error}) {
        ok($input->attr->{class} =~ / is-invalid/, 'Error CSS on input field');
        ok($error_span, 'Got error message div');
        is($error_span->text, $field_args->{error}, 'Got expected error text');
    }
    else {
        ok($input->attr->{class} !~ / is-invalid/, 'No error CSS on input field');
        ok(!$error_span, 'Not got error message div');
    }
}

sub _make_field {
    my ($self, $type, $args) = @_;

    my $field = SongsToTheSiren::Form::Field->new({
       %{ $args },
       type => $type,
    });

    # A renderer is added by the form handler. We need to replicate that here.
    my $renderer_role = 'SongsToTheSiren::Form::Render::' . $type;
    Moose::Util::apply_all_roles($field, $renderer_role);

    return $field;
}

__PACKAGE__->meta->make_immutable;
1;
