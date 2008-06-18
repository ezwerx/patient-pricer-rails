class DictionaryController < ApplicationController

  layout "main"

  def initialize
    $active_tab = 'dictionary'
    $custom_stylesheet1 = ''
  end
  
  def test
    render :text => "hello world!"
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #@word_pages, @words = paginate :words, :order => 'words.text', :per_page => 15
    @words = Word.find(:all, :page => {:size => 5, :current => params[:page], :first => 1})
  end

  def show
    @word = Word.find(params[:id])
    @available_words = Word.find(:all, :order => 'text')
  end

  def new
    $custom_stylesheet1 = 'dictionary/edit.css'
    @word = Word.new
    @available_words = Word.find(:all, :order => 'text')
  end

  def create
    $custom_stylesheet1 = 'dictionary/edit.css'
    Word.transaction do
      @word = Word.new(params[:word])
      if @word.save
        unless params[:children].blank? || params[:children][:synonym_ids].blank?    
          params[:children][:synonym_ids].each do |synonym_id|
            child = Synonym.new
            child.word_id = @word.id
            child.synonym_id = synonym_id
            @word.children << child    
            parent = Synonym.new
            parent.word_id = synonym_id
            parent.synonym_id = @word.id
            @word.parents << parent    
          end  
        end
        flash[:notice] = 'Word was successfully created.'
        redirect_to :action => 'list'
      else
        @available_words = Word.find(:all, :order => 'text')
        render :action => 'new'
      end
    end
  end

  def edit
    $custom_stylesheet1 = 'dictionary/edit.css'
    @word = Word.find(params[:id])
    @available_words = Word.find(:all, :conditions => ["id <> ?",params[:id]],:order => 'text')
  end

  def update
    $custom_stylesheet1 = 'dictionary/edit.css'
    Word.transaction do
      @word = Word.find(params[:id])
      if @word.update_attributes(params[:word])
        Synonym.delete_all(["word_id = ?",@word.id])
        Synonym.delete_all(["synonym_id = ?",@word.id])
        unless params[:children].blank? || params[:children][:synonym_ids].blank?    
          params[:children][:synonym_ids].each do |synonym_id|
            child = Synonym.new
            child.word_id = @word.id
            child.synonym_id = synonym_id
            @word.children << child    
            parent = Synonym.new
            parent.word_id = synonym_id
            parent.synonym_id = @word.id
            @word.parents << parent    
          end  
        end
        flash[:notice] = 'Word was successfully updated.'
        redirect_to :action => 'show', :id => @word
      else
        @available_words = Word.find(:all, :order => 'text')
        render :action => 'edit'
      end
    end
  end

  def destroy
    Word.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
