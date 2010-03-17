# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
admin = User.create
admin.is_admin = true
admin.login = 'admin'
admin.email = 'admin@admin.com' 
admin.password = 'admin'
admin.password_confirmation = 'admin'
admin.first_name = 'Administratör'
admin.last_name = ''
admin.save  
