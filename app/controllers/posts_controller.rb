class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.all

    if params[:fetch_images]
      response = Faraday.get("http://shibe.online/api/shibes?count=5&urls=true&httpsUrls=true")
      @image = JSON.parse(response.body).first
    end

  end

  def show
  end

  def new
    @post = Post.new
    if params[:fetch_images]
      response = Faraday.get("http://shibe.online/api/shibes?count=5&urls=true&httpsUrls=true")
      @image = JSON.parse(response.body).first
    end
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully destroyed.", status: :see_other
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
