ActiveAdmin.register Question do
  permit_params :ques, :correct_answer, :difficulty_level, :language, options_attributes: [:id, :choice, :_destroy]
  
  index do 
    selectable_column   
    id_column
    column :ques
    column :correct_answer
    column :difficulty_level
    column :language
    actions
  end
  
  form do |f|
    f.inputs "Question Details" do
      f.input :ques, label: "Question"
      f.input :correct_answer, label: "Correct Answer"
      f.input :difficulty_level, as: :select, collection: ['Level 1', 'Level 2', 'Level 3'], include_blank: "Select Difficulty Level"
      f.input :language, as: :select, collection: ['Ruby', 'ReactJS', 'ReactNative'], include_blank: "Select Language"
    end

    f.inputs "Options" do
      f.has_many :options, allow_destroy: true, new_record: 'Add Option' do |o|
        o.input :choice, label: "Option"
      end
    end

    f.actions
  end
  
  controller do
    def create
      @question = Question.new(permitted_params[:question])
      if @question.save
        redirect_to admin_questions_path, notice: 'Question created successfully.'
      else
        render :new
      end
    end
  end

  action_item :import_csv, only: :index do
    link_to 'Import CSV', new_import_csv_admin_questions_path
  end

  collection_action :new_import_csv, method: :get do
    @question = Question.new
    render 'admin/questions/import_csv_form'
  end

  collection_action :import_csv, method: :post do
    if params[:question] && params[:question][:csv_file]
      csv_file = params[:question][:csv_file]
      if csv_file.present?
        begin
          skipped_count = 0
          CSV.foreach(csv_file.path, headers: true) do |row|
            question_params = row.to_h.slice('ques', 'correct_answer', 'difficulty_level', 'language')
            choices_param = row['choices']
            
            question = Question.new(question_params)
      
            choices = choices_param.split(',')
        
            choices.each do |choice_text|
              question.options.build(choice: choice_text)
            end
        
            if question.save
              
            else
              skipped_count += 1
            end
          end

          if skipped_count.positive?
            flash[:alert] = "#{skipped_count} question(s) were skipped during CSV import."
          else
            flash[:notice] = "CSV file imported successfully."
          end

          redirect_to admin_questions_path
        rescue StandardError => e
          flash[:error] = "Oops! Invalid File Format. Please upload a valid CSV file with the correct data."
          redirect_to new_import_csv_admin_questions_path
        end
      else
        redirect_to new_import_csv_admin_questions_path, alert: 'No CSV file was uploaded.'
      end
    else
      redirect_to new_import_csv_admin_questions_path, alert: 'No CSV file was uploaded.'
    end
  end
end