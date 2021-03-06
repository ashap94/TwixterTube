class Api::VideosController < ApplicationController

    before_action :require_logged_in, only: [:create, :update, :destroy]

    def show
        @video = Video.find(params[:id])
        render :show
    end

    # 

    def index(query = '')
        query = params['query'] || ''

        if query == ''
            @videos = Video.first(20)
            
            render :index

        else

            query = "%" + query.downcase + "%"
            @users = User.where('lower(username) like ? or lower(about) like ?', query, query)

            if @users.length > 0
                # @videos = Video.where('lower(title) like ? or lower(description) like ?', query, query)
                
                # probably don't need to put videos that match query due to query matching with details of
                # user model in database

                @videos = []

                @users.each do |user| 
                    user.videos.each do |vid|
                        @videos << vid
                    end
                end

                render :search_index
            else
                @videos = Video.where('lower(title) like ? or lower(description) like ?', query, query)
                render :index
            end


        end

    end

    def create
        @video = Video.new(video_params)
        @video.views = 0
        @video.uploader_id = current_user.id
        if @video.save
            render :show
        else
            render json: @video.errors.full_messages, status: 422
        end
    end

    def update
        @video = current_user.videos.find(params[:id])
        if @video.update(video_params_edit)
            render :show
        else
            render json: @video.errors.full_messages, status: 412
        end
    end

    def view_update
        @video = Video.find(params[:id])
        if @video.update(video_params_edit_views)
            render :show
        else
            render json: @video.errors.full_messages, status: 422
        end
    end

    def destroy
        @video = current_user.videos.find(params[:id])
        @video.destroy
        render :show
    end

    def content_creator_vids
        @videos = Video.where("uploader_id = ?", params[:author_id]).sort_by(&:created_at).reverse
        # desired fields from Author User model
        # keys = ["id", "username", "email"]
        @author_model = User.find(params[:author_id]).attributes.slice('id', 'username', 'email')
        
        render :content_creator_vids

        # render json: { 
        #     "videos" => @videos,
        #     "author" => @author_model
        # }, status: 200
    end

    def most_viewed_video
        @video = User.find(params[:author_id]).videos.order("views desc").first
        render :most_viewed_video
    end

    private

    def video_params
        params.require(:video).permit(:title, :description, :vid, :thumbnail)
    end

    def video_params_edit
        params.require(:video).permit(:title, :description, :thumbnail)
    end

    def video_params_edit_views
        params.require(:video).permit(:views)
    end

end
