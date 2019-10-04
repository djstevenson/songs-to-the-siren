package NeverTire::Controller::Admin::Country;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    # $r already has 'require_admin' check applied
    my $a = $r->any('/country')->to(controller => 'admin-country');

    # Capturing a country id
    # my $content_action_a = $a->under('/:country_id')->to(action => 'capture');

    # Admin routes, no capture:
    $a->route('/list')->name('admin_list_countries')->via('GET')->to(action => 'list');
    $a->route('/create')->name('admin_create_country')->via('GET', 'POST')->to(action => 'create');

    # # Admin content, with a capture
    # $content_action_a->route('/edit')->name('admin_edit_content')->via('GET', 'POST')->to(action => 'edit');

    # # Method=DELETE?
    # $content_action_a->route('/delete')->name('admin_delete_content')->via('GET', 'POST')->to(action => 'delete');

}

sub create {
    my $c = shift;

    my $form = $c->form('Country::Create');
    if ($form->process) {
        $c->flash(msg => 'Country created');

        $c->redirect_to('admin_list_countries');
    }
    else {
        $c->stash(form => $form);
    }
}

sub list {
    my $c = shift;

    my $table = $c->table('Country::List');

    $c->stash(table => $table);
}

# sub capture {
#     my $c = shift;

#     my $name = $c->stash->{name};
#     my $rs = $c->schema->resultset('Content');
#     if ( my $content = $rs->find($name) ) {
#         $c->stash( content => $content );
#     }
#     else {
#         $c->reply->not_found;
#         return undef;
#     }

#     return 1;
# }


# sub edit {
#     my $c = shift;

#     my $content = $c->stash->{content};
#     my $form = $c->form('Content::Edit', content => $content);
    
#     if ($form->process) {
#         $c->flash(msg => 'Page updated');

#         $c->redirect_to('admin_list_content');
#     }
#     else {
#         $c->stash(form => $form);
#     }
# }

# sub delete {
#     my $c = shift;

#     my $form = $c->form('Content::Delete', content => $c->stash->{content});
#     if (my $action = $form->process) {
#         $c->flash(msg => $action);
#         $c->redirect_to('admin_list_content');
#     }
#     else {
#         $c->stash(form => $form);
#     }
# }


1;
