# Check if some command available in current shell
def 'is-installed' [ app: string ] {
  ((which $app | length) > 0)
}
