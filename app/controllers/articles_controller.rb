class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "nandang", password: "secret", except: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("articles", partial: "articles/article", locals: { article: @article } ) }
        format.html { redirect_to root_path, notice: "Article was successfully created." } 
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update(article_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@article, partial: "articles/article_details", locals: { article: @article } ) }
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." } 
      else
        format.html { render :edit, status: :unprocessable_entity, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
