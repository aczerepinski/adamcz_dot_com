defmodule AdamczDotCom.BlogController do
  use AdamczDotCom.Web, :controller
  alias AdamczDotCom.Post

  def index(conn, _params) do
    posts = Repo.all(Post)
    render conn, "index.html", posts: posts
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render conn, "show.html", post: post
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)
    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "#{post.title} created")
        |> redirect(to: blog_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "oh noes something went wrong")
        |> redirect(to: blog_path(conn, :index))
    end
    render conn, "new.html", changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post)
    render conn, "edit.html", post: post, changeset: changeset
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)
    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "#{post.title} updated")
        |> redirect(to: blog_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "oh noes something went wrong")
        |> redirect(to: blog_path(conn, :index))
    end
  end

end