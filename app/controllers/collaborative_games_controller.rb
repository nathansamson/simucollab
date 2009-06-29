class CollaborativeGamesController < ApplicationController
  before_filter :find_game, :only => [:show, :edit, :update]
  before_filter :check_game_acl, :only => [:edit, :update]

  def index
    @games = CollaborativeGame.all
  end
  
  def show
  end

  def new
    @game = CollaborativeGame.new
  end

  def edit
  end
    
  def create
    @game = CollaborativeGame.new(params[:collaborative_game])
    @game.coordinator = current_user


    respond_to do |format|
      if @game.save
        flash[:notice] = "Game created"
        format.html { redirect_to(@game) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @game.update_attributes(params[:collaborative_game])

    respond_to do |format|
      if @game.save
        flash[:notice] = "Game updated"
        format.html { redirect_to(@game) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  private
  
    def find_game
      begin
        @game = CollaborativeGame.find(params[:id])    
      rescue
        flash[:error] = "Game not found"
        redirect_to root_url
       end
    end
    
    def check_game_acl
      if !current_user || @game.leader != current_user.email then
        flash[:error] = "You don't have the right to update this game"
        redirect_to root_url
      end
    end

end
