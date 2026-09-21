# Theme1

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://phoenix.hexdocs.pm/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://phoenix.hexdocs.pm/overview.html
* Docs: https://phoenix.hexdocs.pm
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix



Ausi voici la chronologie depuis la creation ou le lancement de phoenix jusqu'a la config de la base de donnée
1. mix phx.new
       ↓
2. Phoenix génère TodoApi.Repo
       ↓
3. config/dev.exs contient la configuration du Repo
       ↓
4. On configure les identifiants PostgreSQL si nécessaire
       ↓
5. mix ecto.create
       ↓
6. PostgreSQL crée todo_api_dev
       ↓
7. mix ecto.gen.migration ...
       ↓
8. mix ecto.migrate
       ↓
9. On crée notre Todo



Pour des issues lorsqu'on essai de faire le create pour lancer ecto il faut s'assurer d'    voir mit le bon mot de passe pour postgress
sudo -u postgres psql
Pour changer le pasword : ALTER USER postgres WITH PASSWORD 'TonMotDePasse';