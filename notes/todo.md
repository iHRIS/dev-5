# ToDo

* Create audit module and tests
** Save audit messages for activity
*** login/logout
*** save/update resource

# Notes

* Search bundles can be filtered with the same constraints as the resource by making it be on entry.where(resource.CONSTRAINT) and replacing entry with the results
** entry.where(resource.name.where(family = 'Duncan'))
** select(entry.where(resource.name.where(family = 'Duncan')))