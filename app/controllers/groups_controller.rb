class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :move, :vote]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @students = @group.students
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  #POST /groups/1/vote
  def vote
    #params: {course_id, student_id}
    enrollment = Taking.where(course_id: params[:course_id], student_id: params[:student_id]).first
    if !enrollment.voted.nil?
      voted_group = Group.find(enrollment.voted)
      voted_group.update(vote: voted_group.vote - 1)
    end
    @group.update(vote: @group.vote + 1)
    enrollment.update(voted: @group.id)
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.vote = 0
    respond_to do |format|
      if @group.save
        course = Course.find(params[:group][:course_id].to_i)
        format.js
        format.html { redirect_to course, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote
    # parse the vote structurem
    # update the database
  end

  
  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    @group.insert_at(group_params[:position].to_i)
    @students = @group.students
    render :show
  end
    


  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { render :show}
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:course_id, :project_name, :description, :vote)
    end
end
