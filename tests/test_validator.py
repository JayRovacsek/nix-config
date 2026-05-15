from src.video_transcoder.validator import FlagValidator

def test_validate_flags_empty():
    assert FlagValidator.validate_flags([]) is True

def test_validate_flags_valid():
    assert FlagValidator.validate_flags(["-crf", "23", "-preset", "slow"]) is True
    assert FlagValidator.validate_flags(["-threads", "4"]) is True

def test_validate_flags_forbidden_chars():
    assert FlagValidator.validate_flags(["-crf;rm -rf /"]) is False
    assert FlagValidator.validate_flags(["-preset `ls`"]) is False
    assert FlagValidator.validate_flags(["-threads &"]) is False

def test_validate_flags_malformed():
    # No leading dash
    assert FlagValidator.validate_flags(["crf", "23"]) is False

def test_validate_flags_path_traversal():
    assert FlagValidator.validate_flags(["-dir", "../../etc/passwd"]) is False
