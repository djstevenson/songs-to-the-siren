package NeverTire::Test::Forms::Fields::Render::TextArea;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;
use Test::Deep qw/ cmp_deeply /;

extends 'NeverTire::Test::Forms::Fields::Render::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_field_render9');

sub run {
    my $self = shift;

    $self->_run_test('Input::TextArea', {
        field_args      => {name => 'your-name'},
        exp_label_attrs => {for => 'test-form-your-name'},
        exp_label       => 'Your name',
        exp_input_attrs => {
            name => 'your-name',
            class => 'form-control',
            placeholder => 'Your name',
			id => 'test-form-your-name',
            rows => 6,
        },
    });

    done_testing;
}

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

    # TODO Sort out duped code with INPUT tests (NeverTire::Test::Forms::Fields::Render::Base)
    ok($dom->at('div')->matches('.form-group'), 'Root is a div with form-group class');
    my $label = $dom->at('div.form-group > label');
    ok($label, 'Root div encloses a label');
    cmp_deeply($label->attr, $exp_label_attrs, 'Got expected attrs for label');
    is($label->text, $exp_label, 'Got expected label text');

    my $input = $dom->at('div.form-group > textarea.form-control');
    ok($input, 'Root div encloses a text area with .form-control');
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

__PACKAGE__->meta->make_immutable;
1;
