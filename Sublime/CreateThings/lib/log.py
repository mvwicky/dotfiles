import logging
import logging.config


def configure_logging(name: str, level: int) -> logging.Logger:
    logging.Formatter.default_msec_format = "%s.%03d"

    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.handlers.clear()

    fmt = "[{asctime}] [{levelname:7}] {name}:{filename} {message}"
    formatter = logging.Formatter(fmt=fmt, style="{")
    if not logger.handlers:
        handler = logging.StreamHandler()
        handler.setFormatter(formatter)
        logger.addHandler(handler)

    # logging.config.dictConfig(
    #     {
    #         "loggers": {name: {"handlers": ["stream"], "level": level}},
    #         "handlers": {
    #             "stream": {
    #                 "level": level,
    #                 "class": "logging.StreamHandler",
    #                 "formatter": "stream",
    #             }
    #         },
    #         "formatters": {"stream": {"style": "{", "format": fmt}},
    #         "incremental": True,
    #         "version": 1,
    #     }
    # )
    return logger
