NEHSAA-MMS
==========

Member Management System of NEHS Alumni Association

## Documentation

- [Wiki Page](https://github.com/NEHSAA/nehsaa-mms/wiki)

## Requirement

- Developer Tools (i.e. gcc/clang)
- [git](http://git-scm.com)
- [RVM (Ruby Version Manager)](https://rvm.io)
- [PostgreSQL](http://www.postgresql.org)
- [Ruby on Rails](http://guides.rubyonrails.org)

## Quick Start

```sh
rvm install ruby-2.1.2
git clone https://github.com/NEHSAA/nehsaa-mms.git
cd nehsaa-mms
bin/bundle install                       # Synchronize Gems
bin/rake db:migrate                      # Initialize Database
bin/rails server                         # Run Server
```

## Contribute to the project

1. Fork the [repository](https://github.com/NEHSAA/nehsaa-mms)
2. Switch to another branch. Ex: `git checkout -b new-branch`
3. Push to your repo (in new-branch, not master)
4. Post a pull request
