seed_logger = Logger.new(STDOUT)
seed_logger.level = :info
Seed::Logger = seed_logger
