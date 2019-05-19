package NeverTire::Test::Forms::Fields::Render::Base;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Deep qw/ cmp_deeply /;

extends 'NeverTire::Test::Base';

use NeverTire::Form::Field;
use NeverTire::Test::Forms::MockForm;

# Tests the general structure of the HTML, e.g. that we're in
# a div.form_group
#
# Example simple render (reformatted):
# <div>
#   <label for="your-name-name">Name</label>
#   <input type="text" id="your-name-name" name="name" autofocus="autofocus" class="pure-input-1" placeholder="Name" value=""/>
# </div>
#
# If the field has an error, this becomes:
# <div>
#   <label for="your-name-name">Name</label>
#   <input type="text" id="your-name-name" name="name" autofocus="autofocus" class="pure-input-1 is-invalid" placeholder="Name" value=""/>
#   <span class="pure-form-message is-invalid">Required</span>
# </div>
#
# Note the extra class on the field, and the extra span.
# Class names here are from Pure CSS



# _run_test: Generic method that is called by the individual test methods to
# separate out common code

sub _run_test {
    my ($self, $type, $args) = @_;

	my $mock_form = NeverTire::Test::Forms::MockForm->new;

    my $field_args      = $args->{field_args};
    my $exp_label_attrs = $args->{exp_label_attrs};
    my $exp_label       = $args->{exp_label};
    my $exp_input_attrs = $args->{exp_input_attrs};

    my $field = $self->_make_field($type, $field_args);

    my $html = $field->render($mock_form);
    my $dom = Mojo::DOM->new($html);

    ok($dom->at('div')->matches('.forum-field-group'), 'Root is a div with forum-field-group class');
    my $label = $dom->at('div.forum-field-group > label');
    ok($label, 'Root div encloses a label');
    cmp_deeply($label->attr, $exp_label_attrs, 'Got expected attrs for label');
    is($label->text, $exp_label, 'Got expected label text');

    my $input = $dom->at('div.forum-field-group > input');
    ok($input, 'Root div encloses an input');
    cmp_deeply($input->attr, $exp_input_attrs, 'Got expected attrs for input');

    my $error_span = $dom->at('div.forum-field-group > span.is-invalid');
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

    my $field = NeverTire::Form::Field->new({
       %$args,
       type => $type,
    });

    # A renderer is added by the form handler. We need to replicate that here.
    my $renderer_role = 'NeverTire::Form::Render::' . $type;
    Moose::Util::apply_all_roles($field, $renderer_role);

    return $field;
}

__PACKAGE__->meta->make_immutable;
1;
