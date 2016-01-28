# desc "Explaining what the task does"
# task :codifligne do
#   # Task goes here
# end

namespace :codifligne do
  def retrieve_or_create_line(params)
    line = Codifligne::Line.where(stif_id: params[:stif_id]).first
    line = Codifligne::Line.new(params) unless line

    line.valid? ? line : nil
  end

  def retrieve_or_create_operator(params)
    operator = Codifligne::Operator.where(stif_id: params[:stif_id]).first
    operator = Codifligne::Operator.new(params) unless operator

    operator.valid? ? operator : nil
  end

  desc 'Populate Codifligne models with stif codifligne api data'
  task populate: :environment do
    client = Codifligne::API.new

    client.operators.each do |params|
      operator = retrieve_or_create_operator(params)
      next unless operator

      puts "--------------------------------------"
      if operator.new_record?
        operator.save
        puts "Create new operator : #{operator.name}"
      else
        operator.update_attributes(params)
        operator.lines =[]
        puts "Updating operator : #{operator.name}"
      end

      # Update operator lines
      client.lines(operator.name).each do |params|
        line = retrieve_or_create_line(params)
        next unless line

        if line.new_record?
          line.save
          puts "Create new line : #{line.name}"
        else
          line.update_attributes(params)
          puts "Updating line : #{line.name}"
        end

        operator.lines << line
      end
    end
  end
end
