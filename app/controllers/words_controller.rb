class WordsController < ApplicationController
  before_action :prepare, only: [:show, :remember, :not_remember]
  before_action :set_word, only: [:edit, :update, :destroy]

  def index
    @words = Word.order('lower(content)').paginate(page: params[:page], per_page: 50)
  end

  def show
  end

  def remember
    @this_word = Word.find_by_id(params[:word_id])
    if @this_word.weight > 0
      @this_word.weight -= 1
      @this_word.save
    end
    render :show
  end

  def not_remember
    @this_word = Word.find_by_id(params[:word_id])
    @this_word.weight += 2
    @this_word.save
    render :show
  end

  # scaffold
  # GET /words/new
  def new
    @word = Word.new
    session[:return_to] ||= request.referer
  end

  # GET /words/1/edit
  def edit
    session[:return_to] ||= request.referer
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to session.delete(:return_to) || new_word_path, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to session.delete(:return_to) || edit_word_path(@word), notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) || root_path, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def prepare
    unit = Unit.find_by_chapter(params[:id])
    @words = unit.words
    if params[:status]
      case params[:status]
      when 'all'
        @words = @words
      when 'never_know'
        @words = @words.where('weight >= 3')
      when 'do_not_know'
        @words = @words.where('weight >= 2')
      when 'barely_know'
        @words = @words.where('weight >= 1')
      when 'got_it'
        @words = @words.where('weight = 0')
      end
    end
    @words = @words.order('lower(content)').paginate(page: params[:page], per_page: 30)
    @chapter = unit.chapter
  end

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:content, :meaning, :weight, :unit_id)
  end
end
