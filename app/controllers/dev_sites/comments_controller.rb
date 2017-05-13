module DevSites
  class CommentsController < ApplicationController
    load_resource :dev_site
    around_action :authenticate_with_token, if: :contains_token
    load_and_authorize_resource :comment, through: :dev_site
    before_action :load_resource, only: [:update, :destroy]

    def index
      @comments = @comments.includes(:votes, :user)
                           .where.not(flagged_as_offensive: Comment::FLAGGED_STATUS)
      @total = @comments.count
      @comments = paginate(@comments, 5)
    end

    def show; end

    def create
      respond_to do |format|
        if @comment.save
          format.json { render :show, status: :ok }
        else
          format.json { render json: @comment.errors, status: 406 }
        end
      end
    end

    def update
      respond_to do |format|
        if @comment.update(comment_params)
          format.json { render json: @comment, status: 200 }
          format.html do
            flash[:notice] = 'The comment has been updated.'
            redirect_to dev_site_path(@dev_site)
          end
        else
          format.json do
            render json: {
              notice: 'Your comment was not updated. Please try again.'
            }, status: 500
          end
        end
      end
    end

    def destroy
      respond_to do |format|
        if @comment.destroy
          format.json { head :no_content, status: 204 }
          format.html do
            flash[:notice] = 'The comment has been deleted.'
            redirect_to dev_site_path(@dev_site)
          end
        else
          format.json do
            render json: {
              notice: 'Your comment was not deleted. Please try again.'
            }, status: 500
          end
        end
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:body,
                                      :commentable_id,
                                      :commentable_type,
                                      :user_id,
                                      :flagged_as_offensive)
    end

    def contains_token
      params[:token].present?
    end

    def load_resource
      @comment ||= Comment.find_by(id: params[:comment_id]) if params[:comment_id]
    end
  end
end
