class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy toggle_complete ]

  # GET /tasks or /tasks.json
  def index
    # Handle sorting
    sort_column = params[:sort] || 'description' # Default sorting column
    sort_direction = params[:direction] || 'asc' # Default sorting direction
  
    @tasks = Task.all
  
    # Handle filtering by category
    if params[:category_id].present?
      @tasks = @tasks.where(category_id: params[:category_id])
    end
  
    # Handle filtering by status
    if params[:status].present?
      @tasks = @tasks.where(status: params[:status])
    end
  
    # Handle sorting for the status column with custom order
    if sort_column == 'status'
      @tasks = @tasks.order(Arel.sql("CASE
                                        WHEN status = 'pending' THEN 1
                                        WHEN status = 'in_progress' THEN 2
                                        WHEN status = 'in_review' THEN 3
                                        WHEN status = 'completed' THEN 4
                                      END #{sort_direction}"))
    else
      # Sorting for other columns
      @tasks = @tasks.order("#{sort_column} #{sort_direction}")
    end
  end
  

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_complete
    if @task.update(is_completed: !@task.is_completed)
      redirect_back(fallback_location: tasks_path, notice: "Task marked as #{@task.is_completed ? 'complete' : 'incomplete'}!")
    else
      redirect_back(fallback_location: tasks_path, alert: "Failed to update task: #{@task.errors.full_messages.join(', ')}")
    end
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:description,:status, :is_completed, :category_id)
    end
end
