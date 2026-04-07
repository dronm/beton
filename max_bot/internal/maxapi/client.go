package maxapi

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"
)

type Client struct {
	baseURL    string
	token      string
	httpClient *http.Client
}

type registerWebhookRequest struct {
	URL         string   `json:"url"`
	UpdateTypes []string `json:"update_types,omitempty"`
	Secret      string   `json:"secret,omitempty"`
}

type apiErrorResponse struct {
	Code        string `json:"code"`
	Message     string `json:"message"`
	Description string `json:"description"`
}

func New(token string, baseURL string, timeout time.Duration) *Client {
	baseURL = strings.TrimRight(strings.TrimSpace(baseURL), "/")
	if baseURL == "" {
		baseURL = "https://platform-api.max.ru"
	}

	if timeout <= 0 {
		timeout = 30 * time.Second
	}

	return &Client{
		baseURL: baseURL,
		token:   strings.TrimSpace(token),
		httpClient: &http.Client{
			Timeout: timeout,
		},
	}
}

func (c *Client) RegisterWebhook(ctx context.Context, webhookURL string, updateTypes []string, secret string) error {
	body, err := json.Marshal(registerWebhookRequest{
		URL:         strings.TrimSpace(webhookURL),
		UpdateTypes: updateTypes,
		Secret:      strings.TrimSpace(secret),
	})
	if err != nil {
		return fmt.Errorf("marshal register webhook request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/subscriptions", bytes.NewReader(body))
	if err != nil {
		return fmt.Errorf("build register webhook request: %w", err)
	}

	req.Header.Set("Authorization", c.token)
	req.Header.Set("Accept", "application/json")
	req.Header.Set("Content-Type", "application/json")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("execute register webhook request: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("read register webhook response: %w", err)
	}

	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		return nil
	}

	apiErr := apiErrorResponse{}
	_ = json.Unmarshal(respBody, &apiErr)

	errMsg := firstNonEmpty(apiErr.Message, apiErr.Description, string(respBody))
	return fmt.Errorf("register webhook http error: %d, %s", resp.StatusCode, errMsg)
}

func firstNonEmpty(values ...string) string {
	for _, value := range values {
		if strings.TrimSpace(value) != "" {
			return value
		}
	}

	return ""
}
