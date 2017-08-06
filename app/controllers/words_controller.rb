class WordsController < ApplicationController
  before_action :prepare, only: [:show, :remember, :not_remember]

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
    @this_word.weight += 1
    @this_word.save
    render :show
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
end
