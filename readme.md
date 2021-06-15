# Sam's Postgres Development Database

This folder contains a postgres database suitable for development by software engineers. It can be run locally using `docker`, deployed into your AWS cloud using `cdk`, and it's DDL is version controlled using `flyway`.

## Local Development

If you're just starting out, run `docker compose up` in this folder - it will start the `postgres` docker service, and then run the `flyway` service, which will run a command that initialises the database with all of the `.sql` files currently in `sql`. If it all runs correctly, you should have a database running locally, at `localhost:5432`!

With that container running, if you need to run any more [flyway commands](https://flywaydb.org/documentation/), you can use the `scripts/flyway-local.sh` helper - e.g. `./scripts/flyway-local.sh clean` to [clean](https://flywaydb.org/documentation/command/clean) your local DB.

Otherwise, feel free to connect to the database using your favorite SQL workbench, update the schema via a migration, or write some code to insert data.

**About Local AWS**

The image used in this docker stack isn't a stock postgres image but rather one that i've built from [chimpler/postgres-aws-s3](https://github.com/chimpler/postgres-aws-s3). This is becaus it supports the `aws_s3` extension, which has proven necessary for some workloads involving glue jobs. This means that you can still build schemas that support glue jobs locally.

**Scripts**

I've put, and will continue to put, some handy bash scripts in `scripts/` that make local development easier. These should be fairly self-explanatory by filename, but will also include a comment at the start of the file.

**Writing Code**

If you're writing code to interact with this database, it's reachable using the port found in `docker-compose.yml`. If you're an expert and want to run your code within docker, e.g. a graphql service that runs in docker locally and gets deployed to lambdas, then you probably already know how to get them talking to each other. If you want to create more users, that's great as well.

## Deployments

The `cdk` for the RDS instance that this database is deployed to lives in `infrastructure/`. (this is still todo)

## On Schema Management

Much about this is written online, so do some reading if you're keen to learn more, but the tl;dr is that database schemas benefit from version control in the same way that code does:
- changes can be incremental
- we can audition locally
- CI/CD can run our schema changes for us
- _we avoid the huge risk of manually running SQL against production databases_
- I repeat: _we avoid the huge risk of manually running SQL against production databases_

The main idea to realise is that with schema-managed databases, the `sql` files in `sql/` aren't one-file-per-table, they're one-file-per-change, with the first file e.g. `V1_init.sql` generally containing the SQL for all tables you see yourself needing to create when you're designing your service, and subsequent files `V2_...sql` and onwards describing changes to the original schema.

So, with schema-managed databases, if you find yourself needing to add an index, or drop a column, these would be expressed in a new `Vx_migration.sql` migration file as `alter table add index` or `alter table drop column` commands, rather than finding an original `create table` statement and changing it. 

This database environment uses [Flyway](https://flywaydb.org/documentation/) as it's schema management tool. The SQL files, or 'migrations', all live in the `sql/` folder, and any that have been run against a flyway-managed database will appear in it's `flyway_schema_history` table. **Any time you run `flyway migrate` against your database, flyway will compare these two locations and run any migrations that haven't been run yet; safely updating your tables safely in live environments**

## todo

- [ ] cdk in `infrastructure/`
- [ ] best practices for deploying flyway to RDS instances?
- [ ] fold into microservice starter