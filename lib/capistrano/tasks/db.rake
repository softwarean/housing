task :load_db, :dump_path do |task_name, params|
  local_db = Database::Local.new(self)
  local_db.load(params[:dump_path], fetch(:db_local_clean))
end
