ActiveAdmin.register Option do
    # See permitted parameters documentation:
    # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
    #
    # Uncomment all parameters which should be permitted for assignment
    #
    permit_params :choice, :question_id, as: :select, collection: Question.pluck(:ques)
    
    # form do|f|
    #     f.input :choice
    #     f.input :question_id, as: :select, collection: Question.pluck(:ques)
    #     f.actions
    # end
    #
    # or
    #
    # permit_params do
    #   permitted = [:name]
    #   permitted << :other if params[:action] == 'create' && current_user.admin?
    #   permitted
    # end
    
end