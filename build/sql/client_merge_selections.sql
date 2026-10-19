-- Persist the merge basket independently for each authenticated user.
CREATE TABLE public.client_merge_selections (
	user_id integer NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
	client_id integer NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
	selected_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (user_id, client_id)
);

-- Needed when another user's merge deletes a source client from all baskets.
CREATE INDEX client_merge_selections_client_id_idx
	ON public.client_merge_selections (client_id);
