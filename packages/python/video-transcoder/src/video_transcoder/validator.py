import re

class FlagValidator:
    """
    Validates FFmpeg flags to ensure they are syntactically correct and safe.
    """
    # Characters that are strictly forbidden in any flag or value to prevent shell injection/path traversal.
    FORBIDDEN_CHARS = [";", "&", "|", "$", "`", ">", "<", "(", ")", "[", "]", "{", "}", "*", "?", "!", '"', "'"]

    @staticmethod
    def validate_flags(flags: list[str]) -> bool:
        """
        Validates a list of FFmpeg flags. 
        Ensures they don't contain dangerous characters or path traversal attempts.
        Also ensures that if an element is a value (doesn't start with '-'), 
        it follows a flag.
        """
        if not flags:
            return True
        
        for i, flag in enumerate(flags):
            # 1. Check for forbidden characters and path traversal in the entire string
            if any(char in flag for char in FlagValidator.FORBIDDEN_CHARS) or ".." in flag:
                return False

            # 2. Check if it's a flag or a value
            if flag.startswith('-'):
                # It's a flag. Must be well-formed (e.g., -crf, -preset).
                if not re.match(r'^-[a-zA-Z0-9_]+', flag):
                    return False
            else:
                # It's a value. Must not be the first element, and must follow a flag.
                if i == 0 or not flags[i-1].startswith('-'):
                    return False

        return True
