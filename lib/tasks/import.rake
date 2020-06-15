namespace :import do
  task admins: :environment do
    desc 'Import admin users.'

    Importer::Admins.call('admins.csv')
  end

  task merchants: :environment do
    desc 'Import merchants.'

    Importer::Merchants.call('merchants.csv')
  end
end
