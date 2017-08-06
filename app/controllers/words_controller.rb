class WordsController < ApplicationController
  def index
    @words = Word.order('lower(content)').paginate(page: params[:page], per_page: 50)
  end

  def show
    unit = Unit.find_by_chapter(params[:id])
    @words = unit.words.order('lower(content)').paginate(page: params[:page], per_page: 30)
    @chapter = unit.chapter
  end
end
