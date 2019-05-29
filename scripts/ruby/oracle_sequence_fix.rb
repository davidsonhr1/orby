require_relative '../../require.rb'
require_relative '../../initialize.rb'
include OrbyInitialize

class Recreate_sequence

    def initialize
        time = Time.new
        @arg = OrbyInitialize.init
        @sequences_file = YAML.load_file("#{__dir__}/config/sequences.yaml")

        printf "Connecting to #{@arg[:url]}/#{@arg[:url].split('-')[1]}, user: #{@arg[:client]} \n"
        @db = Sequel.oracle("#{@arg[:url]}/#{@arg[:url].split('-')[1]}", :user => @arg[:client], :password => ENV['ORACLE_PASSWORD'])
        @log_file = File.new "#{ENV['HOME']}/Desktop/recr_seq_log_#{time.strftime("%Y%m%d_%H%M%S")}.txt","w"
    end

    def init
        #create_core_sequences
        @sequences_file.each{|k,v| recreate(k,v['key'], v['sequence'])}
    end

    private

    def recreate(table, column, sequence)
        printf "=> #{sequence}\n"
        begin
            actual = get_max_key(table, column)
            seq = get_sequence(sequence)

            if actual.nil? || seq.nil?
                raise "this table #{table} or #{seq} not exists"
            else
                if verify_column_value(actual, seq)
                    printf "-- Recreating table #{table.upcase}, #{sequence} is less than the table max number, ( max table value: #{actual}, changing sequence to suggested value: #{actual+1})\n".light_yellow
                    recreate_sequence(sequence, actual+1)
                end
            end

        rescue Sequel::Error => e
            @db.run('rollback')
            error_code = e.message.split(' ')[1].gsub(':', '')
            @log_file.puts ora_exceptions(error_code, e, table, column)
        end 
    end

    def get_max_key(table, column)
        @db[table.to_sym].max(column.to_sym).to_i
    end

    def get_sequence(sequence)
        sequence_obj = @db.fetch("SELECT coalesce(last_number, 0) as sequence FROM all_sequences WHERE sequence_owner = '#{@arg[:client].upcase}' AND sequence_name = '#{sequence.upcase}'").first
        sequence_number = sequence_obj[:sequence].to_i
        sequence_number == nil ? (sequence_number = 0) : (sequence_number = sequence_number)
        return sequence_number
    end

    def verify_column_value(val, seq)
        val > seq ? (true) : (false)
    end

    def recreate_sequence(sequence, value)
        @db.run("drop sequence #{sequence}")
        @db.run("create sequence #{sequence} start with #{value} increment by 1")
    end

    def create_core_sequences
        File.open("#{__dir__}/config/seq_obj.txt").each do |i|
            begin
                printf "Creating #{i}".light_yellow
                system('clear')
                @db.run("create sequence #{i} start with 1 increment by 1")
                @db.run("commit")
            rescue Sequel::Error => e
            end
        end
    end

    def ora_exceptions(error_code, body, table, column)
        if error_code == 'ORA-00904'
            "#{table} - A Coluna usada não foi localizada\n"
        elsif error_code == 'ORA-00972'
            "#{table} - O nome da tabela ou coluna ultraplassa a precisão permitida\n"
        elsif error_code == 'ORA-00942'
            "#{table} - A Tabela não existe\n"
        else
            "#{table} -  #{body} - cod: #{error_code} \n"
        end
    end
end

Recreate_sequence.new.init