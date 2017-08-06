class WordsController < ApplicationController
  def index
    @words = Word.order('lower(content)').paginate(page: params[:page], per_page: 50)
  end

  def show
    unit = Unit.find_by_chapter(params[:id])
    @words = unit.words.order('lower(content)').paginate(page: params[:page], per_page: 30)
    @chapter = unit.chapter
  end

  def remember
    unit = Unit.find_by_chapter(params[:id])
    @words = unit.words.order('lower(content)').paginate(page: params[:page], per_page: 30)
    @chapter = unit.chapter
    @this_word = Word.find_by_id(params[:word_id])
    @this_word.weight -= 1
    @this_word.save unless @this_word.weight < 0
    redirect_to request.referrer
  end

  def not_remember
    unit = Unit.find_by_chapter(params[:id])
    @words = unit.words.order('lower(content)').paginate(page: params[:page], per_page: 30)
    @chapter = unit.chapter
    @this_word = Word.find_by_id(params[:word_id])
    @this_word.weight += 1
    @this_word.save unless @this_word.weight < 0
    redirect_to request.referrer
  end
end
