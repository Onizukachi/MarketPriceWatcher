module MarketPriceWatcher
  module DB
    module Repositories
      module CommonSQLCrudImpl
        def list(**arguments)
          return connection.exec_params("SELECT * FROM #{table_name}").to_a if arguments.empty?

          where_condition = arguments.keys.map.with_index(1) { |key, index| "#{key} = $#{index}" }.join(' AND ')
          query = "SELECT * FROM #{table_name} WHERE #{where_condition}"

          entities = connection.exec_params(query, arguments.values).to_a

          entities.map { |entity| mapper.to_domain(entity) }
        end

        def find(id)
          query = "SELECT * FROM #{table_name} WHERE id = $1"

          entity = connection.exec_params(query, [id]).to_a.first

          mapper.to_domain(entity)
        end

        def create(**attributes)
          keys = attributes.keys.join(', ')
          placeholders = attributes.keys.map.with_index { |_, i| "$#{i + 1}" }.join(', ')

          query = "INSERT INTO #{table_name} (#{keys}) VALUES (#{placeholders}) RETURNING *"

          entity = connection.exec_params(query, attributes.values).to_a.first

          mapper.to_domain(entity)
        end

        def delete(id)
          query = "DELETE FROM #{table_name} WHERE id = $1"

          connection.exec_params(query, [id]).to_a

          id
        end

        def update(id, **attributes)
          set_clause = attributes.keys.map.with_index { |key, i| "#{key} = $#{i + 2}" }.join(', ')

          query = "UPDATE #{table_name} SET #{set_clause} WHERE id = $1 RETURNING *
"
          entity = connection.exec_params(query, attributes.values.unshift(id)).to_a.first

          mapper.to_domain(entity)
        end
      end
    end
  end
end
