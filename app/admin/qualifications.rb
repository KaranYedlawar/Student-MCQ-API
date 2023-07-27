ActiveAdmin.register Qualification do

  permit_params :name

  action_item :import_csv, only: :index do
    link_to 'Import CSV', new_import_csv_admin_qualifications_path
  end

  collection_action :new_import_csv, method: :get do
    @qualification = Qualification.new
    render 'admin/qualifications/import_csv_form'
  end

  collection_action :import_csv, method: :post do
    if params[:qualification] && params[:qualification][:csv_file]
      csv_file = params[:qualification][:csv_file]
      if csv_file.present?
        begin
          CSV.foreach(csv_file.path, headers: true) do |row|
            Qualification.create(name: row['name'])
          end
          redirect_to admin_qualifications_path, notice: 'CSV file imported successfully.'
        rescue StandardError => e
          redirect_to new_import_csv_admin_qualifications_path, alert: "Error importing CSV file: #{e.message}"
        end
      else
        redirect_to new_import_csv_admin_qualifications_path, alert: 'No CSV file was uploaded.'
      end
    else
      redirect_to new_import_csv_admin_qualifications_path, alert: 'No CSV file was uploaded.'
    end
  end

end
