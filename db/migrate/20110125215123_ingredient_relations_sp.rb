class IngredientRelationsSp < ActiveRecord::Migration


  def self.up
     execute <<-__EOI
        CREATE PROCEDURE `RelatedIngredientIDs`( IN root INTEGER )
            NOT DETERMINISTIC
            SQL SECURITY DEFINER
            COMMENT ''
        BEGIN
          DECLARE rows SMALLINT DEFAULT 0;
          DROP TABLE IF EXISTS reached;
          CREATE TABLE reached (
            nodeID INTEGER PRIMARY KEY,
            ir_id Integer
          ) ENGINE=HEAP;
          INSERT INTO reached VALUES (root, 0 );
          SET rows = ROW_COUNT();
          WHILE rows > 0 DO
            INSERT IGNORE INTO reached
              SELECT DISTINCT relation_id, e.id
              FROM ingredient_relations AS e
              INNER JOIN reached AS p ON e.ingredient_id = p.nodeID;
            SET rows = ROW_COUNT();
            INSERT IGNORE INTO reached
              SELECT DISTINCT ingredient_id, e.id
              FROM ingredient_relations AS e
              INNER JOIN reached AS p ON e.relation_id = p.nodeID;
            SET rows = rows + ROW_COUNT();
          END WHILE;
          SELECT * FROM reached;
          DROP TABLE reached;
        END;
     __EOI
  end

   def self.down
     execute "DROP PROCEDURE IF EXISTS `RelatedIngredientIDs`"
   end


end
