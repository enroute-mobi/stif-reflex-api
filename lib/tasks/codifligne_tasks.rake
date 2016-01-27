# desc "Explaining what the task does"
# task :codifligne do
#   # Task goes here
# end

namespace :codifligne do
  desc 'Populate operators'
  task populate: :environment do
    client = Codifligne::API.new

    client.operators.each do |operator|
      unless Codifligne::Operator.exists?(:stif_id => operator.stif_id)
        puts "creating operator : #{operator.name}\n"
        operator.save

        # Assign lines to operator
        client.lines(operator.name).each do |line|
          exist = Codifligne::Line.where(stif_id: line.stif_id).first
          if exist
            operator.lines << exist
          else
            line.save
            operator.lines << line
          end
        end
      end
    end
  end
end
