seed_logger = Logger.new(STDOUT)
seed_logger.level = :debug

Seed::Logger = seed_logger