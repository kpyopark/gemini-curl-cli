# Gemini API Shell Interface

A shell interface for interacting with Google's Gemini AI model through simple command-line inputs.

## Features

- Interactive communication with Google Cloud Platform's Gemini AI model
- Automatic access token caching and renewal
- System Engineer persona configuration
- Concise and clear response generation

## Prerequisites

- Google Cloud SDK (gcloud)
- jq (JSON processing tool)
- curl
- bash shell
- Active Google Cloud project with necessary API permissions

## Setup

1. Create a `.env` file and set the following variables:
```bash
PROJECT_ID="your-project-id"
LOCATION="asia-northeast3"  # or other supported regions
```

2. Ensure Google Cloud SDK is installed and authenticated:
```bash
gcloud auth login
```

3. (Optional) Set up an alias for easier access. Add the following line to your `~/.bashrc` or `~/.zshrc`:
```bash
alias g="/path/to/your/clone/gemini.sh"
```
Then reload your shell configuration:
```bash
source ~/.bashrc  # for bash
# or
source ~/.zshrc   # for zsh
```

## Usage

1. Single-line question:
```bash
source gemini.sh "Enter your question here"
# Or if you've set up the alias:
g "Enter your question here"
```

2. Multi-line question:
```bash
source gemini.sh "First line
Second line
Third line"
# Or if you've set up the alias:
g "First line
Second line
Third line"
```

## Technical Details

### Token Management
- Access token stored in `/tmp/gcloud_access_token`
- Token timestamp stored in `/tmp/gcloud_token_timestamp`
- Tokens valid for 50 minutes, automatically renewed upon expiration

### API Configuration
- Model: gemini-1.5-flash-001
- Temperature: 0.4 (controls response creativity)
- Max Output Tokens: 8192
- Top-P: 0.95
- Top-K: 40

### System Configuration
- Configured with System Engineer persona for concise and clear responses
- Responses parsed through jq to output text only

## Notes

- curl output is silenced with the `-s` option
- Input text is automatically JSON escaped
- System supports both English and Korean languages

## Important Considerations

- Project ID and location must be configured in the `.env` file
- Appropriate API permissions must be set in your Google Cloud project
- Token files are stored in temporary directory and will be regenerated upon system restart

## Security Notes

- Access tokens are automatically managed and renewed
- Temporary storage of tokens in `/tmp` directory
- Make sure to protect your `.env` file containing project credentials

## Error Handling

The script handles common errors including:
- Invalid or expired tokens
- Missing environment variables
- API connection issues
- Invalid input formatting

## Maintenance

- Check Google Cloud billing and usage regularly
- Monitor API quotas and limits
- Keep the Google Cloud SDK updated
- Regularly update your authentication credentials

## Support

For issues related to:
- Google Cloud Platform: Visit Google Cloud Support
- Gemini API: Refer to Google's Gemini API documentation
- Script issues: Check the error output and logs

## Contributing

Feel free to submit issues and enhancement requests. Contributions are welcome with appropriate test coverage.
