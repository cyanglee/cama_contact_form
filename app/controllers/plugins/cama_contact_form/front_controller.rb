class Plugins::CamaContactForm::FrontController < CamaleonCms::Apps::PluginsFrontController
  include Plugins::CamaContactForm::MainHelper
  include Plugins::CamaContactForm::ContactFormControllerConcern
  
  # here add your custom functions
  def save_form
    flash[:contact_form] = {}
    @form = current_site.contact_forms.find_by_id(params[:id])
    fields = params[:fields]
    errors = []
    success = []

    perform_save_form(@form, fields, success, errors)
    if success.present?
      flash[:contact_form][:notice] = success.join('<br>')
    else
      flash[:contact_form][:error] = errors.join('<br>')
      flash[:values] = fields.delete_if{|k, v| v.class.name == 'ActionDispatch::Http::UploadedFile' }
    end
    params[:format] == 'json' ? render(json: flash[:contact_form].to_hash) : (redirect_to :back)
  end

end
