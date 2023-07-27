ActiveAdmin.register Option do

    permit_params :choice, :question_id

    form do|f|
        f.inputs "Choice Details" do
            f.input :choice
            f.input :question_id, as: :select, collection: Question.pluck(:ques,:id)
        end
        f.actions
    end
end
