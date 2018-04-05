seed_logger = Logger.new(STDOUT)
seed_logger.level = :info #:debug

Seed::Logger = seed_logger
