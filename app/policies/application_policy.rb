class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    super_user_or_manager?
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    user.manager?
  end

  def new?
    create?
  end

  def update?
    user.manager?
  end

  def edit?
    update?
  end

  def destroy?
    user.manager?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
  
  delegate :manager?, to: :user
  
  delegate :super_user?, to: :user
  
  def super_user_or_manager?
    user.super_user? || user.manager?
  end
  
  # rails admin fiels
  
  def dashboard?
    super_user_or_manager? 
  end
  
  def export?
    super_user_or_manager?
  end
  
  def show_in_app?
    show?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
