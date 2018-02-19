class TasksController < ApplicationController
    before_action :require_user_logged_in
    before_action :set_task, only:[:show, :edit, :update, :destroy]
    before_action :user_check, only:[:show, :edit, :update, :destroy]
    
    def index
        if logged_in?
            @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
        end
    end
    
    def show
        set_task
        user_check
    end
    
    def new
        @task = Task.new
    end
    
    def create
        @task = current_user.tasks.build(task_params)
        
        if @task.save
            flash[:success] = 'タスクの投稿が完了しました'
            redirect_to @task
        else
            @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
            flash[:danger] = 'タスクが投稿されませんでした'
            render :new
        end
    end
    
    def edit
        user_check
    end
    
    def update
        user_check
        
        if @task.update(task_params)
            flash[:success] = 'タスクは正常に更新されました'
            redirect_to @task
        else
            flash.now[:danger] = 'タスクが更新されませんでした'
            render :edit
        end
    end
    
    def destroy
        user_check
        
        @task.destroy
        
        flash[:success] = 'タスクが削除されました'
        redirect_to tasks_url
    end
    
    private
    
    def set_task
        @task = Task.find(params[:id])
    end
    
    def task_params
        params.require(:task).permit(:content, :status)
    end
    
    def user_check
        if current_user != @task.user
            redirect_to root_url
        end
    end
end
